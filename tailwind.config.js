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
  // By default, Tailwind shakes the CSS file down to only those classes that are actually in use.
  // This makes development a *huge* pain, since if you use any class for the first time, you must
  // clobber and recompile the base Tailwind stylesheet (since this doesn't happen as eagerly as
  // changes to your own application styles). This pattern ensures all classes are included when
  // running in development.
  safelist: (process.env.NODE_ENV === 'development' ? [{ pattern: /./ }] : []),
}
