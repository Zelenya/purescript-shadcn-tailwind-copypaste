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

- use es build (or smth) instead of parcel
- use something like `tanstack query` to fetch data
- deal with the configs hell

*(contributions & suggestions are welcome)*

### Excuses

*This was ripped out from an existing project, so some parts might be mmissing or feel out of place. It's far from perfect (especially, the configuration and build part). Showing highly optimized builds or anything like that is not the goal of this project.*

- there is no logging out (you have to manually remove the token from the storage)
- the token handling isn't great either; for example, there is no mutex on refresh
- there is not memoization
- there is no smooth transitions 
- and on and on

## How does it work?

Article: TBD

Video: https://youtu.be/Vgn5hEVK7lU

## Tooling and setting things up

```shell
npm install
npm start
```

It's recommended to have a [purescript language server](https://github.com/nwolverson/purescript-language-server) working with an editor, e.g. you could use vscode with [ide-purescript](https://marketplace.visualstudio.com/items?itemName=nwolverson.ide-purescript)
