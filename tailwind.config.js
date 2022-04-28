const pluginTailwindForms = require('@tailwindcss/forms')
const pluginTailwindAspectRatio = require('@tailwindcss/aspect-ratio')
const pluginTailwindTypography = require('@tailwindcss/typography')
const pluginFlowbite = require('flowbite/plugin')

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
}
