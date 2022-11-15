import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'searchBox',
    'searchByTextForm',
    'searchByTextFieldset',
    'searchByTextField',
    'searchByMediaForm',
    'searchByMediaFieldset',
    'searchByMediaFileInput',
  ]

  searchBoxTargetConnected(element) {
    element.ondragover = (event) => {
      event.preventDefault()
      element.style.opacity = 0.5
    }

    element.ondragenter = (event) => {
      event.preventDefault()
    }

    element.ondragleave = (event) => {
      event.preventDefault()
      element.style.opacity = 1
    }

    element.ondrop = (event) => {
      event.preventDefault()
      element.style.opacity = 1

      if (event.dataTransfer.files.length > 0) {
        this.searchByMediaFileInputTarget.files = event.dataTransfer.files
        this.switchToMediaMode()
        this.searchByMediaFormTarget.requestSubmit()
      }
    }
  }

  switchToMediaMode() {
    this.searchBoxTarget.classList.add('search-box--media-mode')
    this.searchBoxTarget.classList.remove('search-box--text-mode')
  }

  switchToTextMode() {
    this.searchBoxTarget.classList.add('search-box--text-mode')
    this.searchBoxTarget.classList.remove('search-box--media-mode')
  }

  onMediaSearch(event) {
    if (this.searchByMediaFileInputTarget.files.length === 0) {
      event.preventDefault()
      alert('You need to choose an image or video to search by.')
    } else {
      this.searchByTextFieldsetTarget.disabled = true
    }
  }

  // See #456 for why we aren't using Turbo here.
}
