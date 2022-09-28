// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AccountController from "./account_controller.js"
application.register("account", AccountController)

import AuthorController from "./author_controller.js"
application.register("author", AuthorController)

import FlashBoxController from "./flash_box_controller.js"
application.register("flash-box", FlashBoxController)

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import ImageSearchController from "./image_search_controller.js"
application.register("image-search", ImageSearchController)

import JobsStatusController from "./jobs_status_controller.js"
application.register("jobs-status", JobsStatusController)

import MediaVault__ArchiveController from "./media_vault/archive_controller.js"
application.register("media-vault--archive", MediaVault__ArchiveController)

import ModalController from "./modal_controller.js"
application.register("modal", ModalController)
