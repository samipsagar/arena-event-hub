// @ts-check
const eslint = require('@eslint/js');
const { defineConfig } = require('eslint/config');
const tseslint = require('typescript-eslint');
const angular = require('angular-eslint');
const boundaries = require('eslint-plugin-boundaries');
const prettier = require('eslint-config-prettier/flat');

/**
 * The architectural layers. Order matters: a file takes the type of the first
 * pattern that matches, so `dto` precedes `data-access` and `entity` precedes
 * `domain` — each is nested inside the folder listed after it.
 */
const layers = [
  { type: 'core', pattern: 'src/app/core' },
  { type: 'shared', pattern: 'src/app/shared' },
  { type: 'dto', pattern: 'src/app/features/*/data/dto' },
  { type: 'data', pattern: 'src/app/features/*/data' },
  { type: 'entity', pattern: 'src/app/features/*/domain/entity' },
  { type: 'domain', pattern: 'src/app/features/*/domain' },
  { type: 'presentation', pattern: 'src/app/features/*/presentation' },
];

/** `from` may import `to`; everything else is an error. */
const may = (from, to) => ({
  from: { element: { type: from } },
  allow: { to: { element: { types: { anyOf: to } } } },
});

module.exports = defineConfig([
  {
    files: ['**/*.ts'],
    extends: [
      eslint.configs.recommended,
      tseslint.configs.recommended,
      tseslint.configs.stylistic,
      angular.configs.tsRecommended,
    ],
    processor: angular.processInlineTemplates,
    rules: {
      '@angular-eslint/directive-selector': [
        'error',
        { type: 'attribute', prefix: 'arena', style: 'camelCase' },
      ],
      '@angular-eslint/component-selector': [
        'error',
        { type: 'element', prefix: 'arena', style: 'kebab-case' },
      ],
      // A leading underscore means "deliberately unused", and destructuring a
      // field out via `...rest` is an omission, not a forgotten variable.
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          caughtErrorsIgnorePattern: '^_',
          destructuredArrayIgnorePattern: '^_',
          ignoreRestSiblings: true,
        },
      ],
    },
  },
  {
    files: ['**/*.html'],
    extends: [angular.configs.templateRecommended, angular.configs.templateAccessibility],
    rules: {},
  },
  {
    files: ['src/**/*.ts'],
    plugins: { boundaries },
    settings: {
      'boundaries/elements': layers,
      // The bundled node resolver only knows .js/.json, so every .ts import
      // would come back unresolved and silently pass.
      'import/resolver': {
        // Without this every .ts import resolves to nothing — and an
        // unresolved import silently PASSES the boundary check.
        typescript: { project: 'tsconfig.json' },
        node: { extensions: ['.ts', '.tsx', '.js', '.jsx', '.json'] },
      },
    },
    rules: {
      'boundaries/dependencies': [
        'error',
        {
          default: 'disallow',
          policies: [
            may('core', ['core']),
            may('shared', ['shared', 'core']),
            may('dto', ['dto', 'core']),
            // Mappers live here: the only place DTO and entity are both in scope.
            may('data', ['data', 'dto', 'entity', 'domain', 'core']),
            may('entity', ['entity']),
            may('domain', ['domain', 'entity', 'data', 'core']),
            // Reaches the service and the store, never the repository or a DTO.
            may('presentation', ['presentation', 'domain', 'entity', 'shared', 'core']),
          ],
        },
      ],
    },
  },
  // Last, so it switches off every rule Prettier already decides.
  prettier,
]);
