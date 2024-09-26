import { main } from '../output/Main'

// Hot reloading. See https://parceljs.org/features/development/#hot-reloading
if (module.hot) {
  module.hot.accept(function () {
    main()
  })
}

main()
