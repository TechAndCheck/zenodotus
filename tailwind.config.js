const pluginTailwindForms = require('@tailwindcss/forms')
const pluginTailwindAspectRatio = require('@tailwindcss/aspect-ratio')
const pluginTailwindTypography = require('@tailwindcss/typography')
const pluginFlowbite = require('flowbite/plugin')

// Classes used for dynamically-generated color themes for the flash alerts.
// Should be kept up to date with changes in `_flashes.html.erb`.
const flashColorClasses = [
  'bg-yellow-100',
  'dark:bg-yellow-200',
  'dark:hover:bg-yellow-300',
  'hover:bg-yellow-200',
  'text-yellow-500',
  'text-yellow-700',
  'dark:text-yellow-600',
  'dark:text-yellow-800',
  'focus:ring-yellow-400',
  'bg-blue-100',
  'dark:bg-blue-200',
  'dark:hover:bg-blue-300',
  'hover:bg-blue-200',
  'text-blue-500',
  'text-blue-700',
  'dark:text-blue-600',
  'dark:text-blue-800',
  'focus:ring-blue-400',
  'bg-green-100',
  'dark:bg-green-200',
  'dark:hover:bg-green-300',
  'hover:bg-green-200',
  'text-green-500',
  'text-green-700',
  'dark:text-green-600',
  'dark:text-green-800',
  'focus:ring-green-400',
  'bg-red-100',
  'dark:bg-red-200',
  'dark:hover:bg-red-300',
  'hover:bg-red-200',
  'text-red-500',
  'text-red-700',
  'dark:text-red-600',
  'dark:text-red-800',
  'focus:ring-red-400',
]

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
    },
  },
  plugins: [
    pluginTailwindForms,
    pluginTailwindAspectRatio,
    pluginTailwindTypography,
    pluginFlowbite,
  ],
  safelist: [
    // The safelist contains classes that we want included even if they aren't discovered by the
    // code analyzer while building the condensed Tailwind CSS file. This will usually be because
    // the classes are generated dynamically through string concatenation. Please document the
    // reason for adding to this list so we know when we can remove them.
    ...flashColorClasses,
  ],
}
