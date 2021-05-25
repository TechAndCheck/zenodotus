const colors = require('tailwindcss/colors')

module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      transparent: 'transparent',
      current: 'currentColor',
      bluegray: colors.blueGray, // Note: none of this works, so we're not using custom colors at the moment
    },
    fontFamily: {
      display: ['Barlow Semi Condensed', 'sans-serif'],
      body: ['Open Sans', 'sans-serif'],
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
