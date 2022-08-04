import { Controller } from '@hotwired/stimulus'
import consumer from '../channels/consumer';

export default class extends Controller {
  static targets = ['scrapesPill', 'jobsPill']

  initialize() {
    this.loadedScrapesCount = Number(this.element.dataset.loadedScrapesCount)
    this.loadedJobsCount = Number(this.element.dataset.loadedJobsCount)
  }

  reloadScrapes() {
    const scrapes = document.getElementById('scrapes')
    const src = scrapes.src
    scrapes.src = null
    scrapes.src = src
    this.scrapesPillTarget.innerText = ''
    this.scrapesPillTarget.hidden = true
  }

  reloadJobs() {
    const jobs = document.getElementById('jobs')
    const src = jobs.src
    jobs.src = null
    jobs.src = src
    this.jobsPillTarget.innerText = ''
    this.jobsPillTarget.hidden = true
  }

  connect() {
    this.jobs_channel = consumer.subscriptions.create('JobsChannel', {
      connected: this._jobsCableConnected.bind(this),
      disconnected: this._jobsCableDisconnected.bind(this),
      received: this._jobsCableReceived.bind(this),
    });

    this.scrapes_channel = consumer.subscriptions.create('ScrapesChannel', {
      connected: this._scrapesCableConnected.bind(this),
      disconnected: this._scrapesCableDisconnected.bind(this),
      received: this._scrapesCableReceived.bind(this),
    });
  }

  _jobsCableConnected() {
    // Called when the subscription is ready for use on the server
    console.log("Jobs Connected...")
  }

  _jobsCableDisconnected() {
    // Called when the subscription has been terminated by the server
  }

  _jobsCableReceived(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received Jobs......." + data)
    const unloadedJobsCount = data["jobs_count"] - this.loadedJobsCount
    this.jobsPillTarget.hidden = false
    this.jobsPillTarget.innerText = unloadedJobsCount + " new jobs submitted..."

  }

  _scrapesCableConnected() {
    // Called when the subscription is ready for use on the server
  }

  _scrapesCableDisconnected() {
    // Called when the subscription has been terminated by the server
  }

  _scrapesCableReceived(data) {
    // Called when there's incoming data on the websocket for this channel
    const unloadedScrapesCount = data["scrapes_count"] - this.loadedScrapesCount
    this.scrapesPillTarget.hidden = false
    this.scrapesPillTarget.innerText = unloadedScrapesCount + " new scrapes submitted..."
  }
}