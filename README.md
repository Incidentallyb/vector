# Vector

[![Netlify Status](https://api.netlify.com/api/v1/badges/52002e9f-419a-4ebe-9ac0-6fe230e014d4/deploy-status)](https://app.netlify.com/sites/lab-collective-vector/deploys)

[Current release](https://lab-collective-vector.netlify.app)

## Code and configs
- Static code generated with [elm](https://elm-lang.org/docs) and [webpack](https://webpack.js.org)
- Deployed and hosted by [Netlify](https://www.netlify.com/)
- `elm.json` for elm packages
- `package.json` for node scripts and packages
- `yarn.lock` for current versions of node packages
- `webpack.config.js` for build config
- `.netlify.toml` for deploy config
- `src/*` contains app source files

## Development

### Prerequisites
- [elm](http://elm-lang.org/) 0.19
- [node](https://nodejs.org/)
- [nvm for macOS & Linux](https://github.com/nvm-sh/nvm) or [nvm for Windows](https://github.com/coreybutler/nvm-windows)
- [yarn](https://classic.yarnpkg.com/en/docs)

### Formatting
We recommend integrating `elm-format@0.8.3` into your code editor, but if you don't...
- Please `yarn format` to format `.elm` files in `src` before committing code.

### Build
- `yarn start` for a hot reload server at [http://localhost:3000](http://localhost:3000)
- `yarn build` to generate a production build in `dist`

### Test

- Todo

## Deployment

- When a pull request is created against `main`, netlify builds a preview site
- When code is merged into `main` it is deployed to [current release](https://lab-collective-vector.netlify.app)
