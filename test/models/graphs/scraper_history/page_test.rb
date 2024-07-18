require "test_helper"

class PageTest < ActiveSupport::TestCase
  def test_creating_a_page_node
    page = Page.create(url: "https://example.com", host_name: "example.com")
    assert_predicate(page, :valid?)
  end

  def test_page_node_requires_url
    page = Page.create(host_name: "example.com")
    assert_not page.valid?
  end

  def test_page_node_requires_host_name
    page = Page.create(url: "https://example.com")
    assert_not page.valid?
  end

  def test_page_node_requires_url_and_host_name
    page = Page.create
    assert_not page.valid?
  end

  def test_page_node_requires_url_to_be_unique
    page = Page.create(url: "https://example.com", host_name: "example.com")
    assert_predicate(page, :valid?)

    page = Page.create(url: "https://example.com", host_name: "example.com")
    assert_not page.valid?
  end
end
