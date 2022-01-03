const { environment } = require('@rails/webpacker')

const globImporter = require('node-sass-glob-importer');

environment
    .loaders
    .get('sass')
    .use
    .find(item => item.loader === 'sass-loader')
    .options = { sassOptions: { importer: globImporter() } }; // <-- this!

module.exports = environment
