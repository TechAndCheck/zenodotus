// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
// Note: This should not be necessary. I'm unsure why it is necessary.
//       In fact, it's a little troubling that it *is* necessary.
//       It's further troubling that the controllers inside `controllers/media_vault` are not
//       namespaced as `media-vault--{name}` the way we would totally expect. Much troubling.
eagerLoadControllersFrom("controllers/media_vault", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
