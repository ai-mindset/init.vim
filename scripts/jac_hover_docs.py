"""Read Python documentation for a definition returned by Jac's LSP."""

import ast
import importlib
import importlib.machinery
import inspect
import json
from pathlib import Path
import sys
import sysconfig


DECLARATIONS = (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)


def declaration_at(tree, line):
    """Return the qualified name and node containing a zero-based LSP line."""
    found = []

    def walk(node, names):
        for child in ast.iter_child_nodes(node):
            qualified = names
            if isinstance(child, DECLARATIONS):
                qualified = names + [child.name]
                first = min([child.lineno] + [d.lineno for d in child.decorator_list])
                # LSP definitions point at the declaration header. A field or
                # assignment inside a class/function must not get its parent's doc.
                body_start = child.body[0].lineno if child.body else child.end_lineno + 1
                if first <= line + 1 < body_start or line + 1 == child.lineno:
                    found.append((qualified, child))
            walk(child, qualified)

    walk(tree, [])
    return max(found, key=lambda item: len(item[0]), default=([], None))


def parse_file(path):
    # Documentation lookup should stay cheap even for generated libraries.
    if path.stat().st_size > 2 * 1024 * 1024:
        return None
    import tokenize

    with tokenize.open(path) as source:
        return ast.parse(source.read(), filename=str(path))


def stub_module(path):
    """Infer import names only from recognized typeshed layouts."""
    parts = path.parts
    for index, part in enumerate(parts):
        if part != "typeshed" or index + 2 >= len(parts):
            continue
        if parts[index + 1] == "stdlib":
            relative = list(parts[index + 2:])
            stdlib = True
        elif parts[index + 1] == "stubs" and index + 3 < len(parts):
            relative = list(parts[index + 3:])  # Skip the distribution name.
            stdlib = False
        else:
            continue
        relative[-1] = Path(relative[-1]).stem
        if relative[-1] == "__init__":
            relative.pop()
        if relative and all(part.isidentifier() for part in relative):
            return ".".join(relative), stdlib
    return None, False


def standard_library_doc(module, names):
    if module.split(".")[0] not in sys.stdlib_module_names:
        return None
    # Exclude the project and site-packages from stdlib import resolution.
    stdlib = Path(sysconfig.get_path("stdlib")).resolve()
    original = sys.path[:]
    try:
        sys.path[:] = [str(stdlib), str(stdlib / "lib-dynload")]
        value = importlib.import_module(module)
        for name in names:
            value = inspect.getattr_static(value, name)
            if isinstance(value, (staticmethod, classmethod)):
                value = value.__func__
        return inspect.getdoc(value)
    finally:
        sys.path[:] = original


def library_source(module, root):
    """Locate installed .py files without importing their packages."""
    paths = []
    for environment in (root / ".jac" / "venv", root / ".venv"):
        paths.extend(str(path) for path in environment.glob("lib/python*/site-packages"))
        if (environment / "Lib" / "site-packages").is_dir():
            paths.append(str(environment / "Lib" / "site-packages"))
    paths.extend(sys.path)
    full_name = ""
    for name in module.split("."):
        full_name = f"{full_name}.{name}" if full_name else name
        spec = importlib.machinery.PathFinder.find_spec(full_name, paths)
        if spec is None:
            return None
        paths = list(spec.submodule_search_locations or [])
    if spec.origin and spec.origin.endswith(".py"):
        return Path(spec.origin)
    return None


def named_doc(tree, names):
    scope = tree
    for name in names:
        # Include declarations inside platform/version conditional blocks.
        pending = list(ast.iter_child_nodes(scope))
        scope = None
        while pending:
            child = pending.pop(0)
            if isinstance(child, DECLARATIONS):
                if child.name == name:
                    scope = child
                    break
            else:
                pending.extend(ast.iter_child_nodes(child))
        if scope is None:
            return None
    return ast.get_docstring(scope)


def documentation(request):
    path = Path(request["path"])
    if path.suffix not in (".py", ".pyi"):
        return None
    tree = parse_file(path)
    if tree is None:
        return None
    names, declaration = declaration_at(tree, request["line"])
    if declaration is None:
        return None
    doc = ast.get_docstring(declaration)
    if doc or path.suffix == ".py":
        return doc
    module, stdlib = stub_module(path)
    if module is None:
        return None
    if stdlib:
        return standard_library_doc(module, names)
    source = library_source(module, Path(request["root"]))
    if source:
        tree = parse_file(source)
        if tree:
            return named_doc(tree, names)
    return None


def main():
    result = {}
    try:
        doc = documentation(json.load(sys.stdin))
    except Exception as error:
        doc = None
        result["error"] = f"{type(error).__name__}: {error}"
    result["documentation"] = doc
    print(json.dumps(result))


if __name__ == "__main__":
    main()
