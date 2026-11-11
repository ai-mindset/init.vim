// Bun implements these named language plugins and their rules natively.
// This Bun-specific config needs neither ESLint nor external parser packages.
const markdown = { meta: { name: "@eslint/markdown" } };
const json = { meta: { name: "@eslint/json" } };
const filetype = process.env.NVIM_BUN_FILETYPE;
const jsonLanguages = ["json", "jsonc", "json5"];
const bufferLanguage = jsonLanguages.includes(filetype) ? filetype : null;

export default [
  {
    files: ["**/*.{md,markdown,mkd,mkdn,mdwn,mdown}"],
    plugins: { markdown },
    language: "markdown/gfm",
    languageOptions: { frontmatter: "yaml" },
    rules: {
      "markdown/fenced-code-language": "warn",
      "markdown/heading-increment": "warn",
      "markdown/no-duplicate-definitions": "error",
      "markdown/no-duplicate-headings": "warn",
      "markdown/no-empty-definitions": "error",
      "markdown/no-empty-images": "warn",
      "markdown/no-empty-links": "warn",
      "markdown/no-invalid-label-refs": "error",
      "markdown/no-missing-label-refs": "error",
      "markdown/no-reversed-media-syntax": "error",
      "markdown/no-unused-definitions": "warn",
      "markdown/require-alt-text": "warn",
      "markdown/table-column-count": "error",
    },
  },
  ...(bufferLanguage ? [bufferLanguage] : jsonLanguages).map((language) => ({
    files: [bufferLanguage ? "**/*.{json,jsonc,json5}" : `**/*.${language}`],
    plugins: { json },
    language: `json/${language}`,
    ...(language === "jsonc"
      ? { languageOptions: { allowTrailingCommas: true } }
      : {}),
    rules: {
      "json/no-duplicate-keys": "error",
      "json/no-unsafe-values": "error",
    },
  })),
];
