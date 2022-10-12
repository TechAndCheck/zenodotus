const pluginTailwindForms = require('@tailwindcss/forms')
const pluginTailwindAspectRatio = require('@tailwindcss/aspect-ratio')
const pluginTailwindTypography = require('@tailwindcss/typography')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    pluginTailwindForms,
    pluginTailwindAspectRatio,
    pluginTailwindTypography,
  ],
}
