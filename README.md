# purescript + shadcn + tailwind (copypaste)

This repository serves two purposes:

- as a minimal interesting project that can be used to play around with PureScript
- as a bootstrapping project for PureScript + React + Tailwind

## What CAN be found here

### Major concepts/stack

- [shadcn](https://ui.shadcn.com/) ui components (also demos using typescript from purescript)
- [tailwind css](https://tailwindcss.com/)
- `react-basic` with `react-basic-dom-beta` (which is more tailwind- and copypaste-friendly)

### Minor things

- routing with `routing-duplex` and `web-router`
- ergonomic FFI with `undefined-is-not-a-problem`
- copy-paste with `web-clipboard`
- basic usage of `fetch`, `fetch-yoga-json`, `yoga-json`
- primitive authentication with local storage (`web-storage`)
- service/handler pattern

## What CAN'T be found here

### Not implemented yet

- use something like `tanstack query` to fetch data

*(contributions & suggestions are welcome)*

### Excuses

*This was ripped out from an existing project, so some parts might be missing or feel out of place. It's far from perfect. Showing highly optimized builds or anything like that is not the goal of this project.*

- there is no logging out (you have to manually remove the token from the storage)
- the token handling isn't great either; for example, there is no mutex on refresh
- there is not memoization
- there is no smooth transitions
- and on and on

## How does it work?

Video: https://youtu.be/Vgn5hEVK7lU

## Getting started

```shell
npm install
npm start
```

This starts a development server at http://localhost:1234 with live reload.

It's recommended to have a [purescript language server](https://github.com/nwolverson/purescript-language-server) working with an editor, e.g. you could use vscode with [ide-purescript](https://marketplace.visualstudio.com/items?itemName=nwolverson.ide-purescript)

## Build scripts

| Command | Description |
|---------|-------------|
| `npm start` | Development server with live reload (port 1234) |
| `npm run bundle` | Production build to `dist/` |
| `npm run build` | Compile PureScript only |
| `npm run build:css` | Compile Tailwind CSS only |

## Environment configuration

This is hacky and simplified, but it works. The app supports Production and Staging environments. API URLs are defined in `src/Config.purs`.

In development, switch between environments by editing `src/index.js`:

```javascript
main({"type" : "Dev", "value": "Production" })  // use production APIs
// main({"type" : "Dev", "value": "Staging" })  // use staging APIs
```

The production build (`npm run bundle`) always uses `Live` environment.
