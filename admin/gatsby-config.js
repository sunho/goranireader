module.exports = {
    siteMetadata: {
        title: `Gorani Reader Admin`,
    },
    plugins: [
        {
            resolve: 'gatsby-plugin-sass',
            options: {
                includePaths: ['src/styles']
            }
        },
        'gatsby-plugin-typescript',
        'gatsby-plugin-tslint',
        'gatsby-plugin-react-svg'
    ],
}
