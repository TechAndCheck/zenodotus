class SiteDefinitions
  # Given a domain such as `www.example.com`, returns the `www` portion.
  #
  # Note that this is not a generalizable method; it's based on our known domain pattern
  # and would fail on something general like `www.example.co.uk`.
  def self.extract_subdomain(url)
    host = URI(url).host
    host_segments = host.split(".").reverse
    host_segments[2]
  end

  FACT_CHECK_INSIGHTS = {
    shortname: "fact_check_insights",
    title: "Fact-Check Insights",
    url: Figaro.env.FACT_CHECK_INSIGHTS_URL,
    subdomain: self.extract_subdomain(Figaro.env.FACT_CHECK_INSIGHTS_URL),
  }

  MEDIA_VAULT = {
    shortname: "media_vault",
    title: "MediaVault",
    url: Figaro.env.MEDIA_VAULT_URL,
    subdomain: self.extract_subdomain(Figaro.env.MEDIA_VAULT_URL),
  }

  # This is for the meta-programming magic below.
  ALL = [
    FACT_CHECK_INSIGHTS,
    MEDIA_VAULT,
  ]

  # Make the contents of ALL available by the given attribute, in both string and symbol form.
  def self.generate_index_by(attr)
    ALL.index_by { |site| site[attr] }.merge(ALL.index_by { |site| site[attr].to_sym })
  end

  # Make the contents of ALL available by the hostname (which is a simplified version of the URL),
  # in both string and symbol form.
  def self.generate_index_by_host
    ALL.index_by { |site| URI(site[:url]).host }.merge(ALL.index_by { |site| URI(site[:url]).host.to_sym })
  end

  BY_SHORTNAME = self.generate_index_by(:shortname)
  BY_TITLE = self.generate_index_by(:title)
  BY_URL = self.generate_index_by(:url)
  BY_SUBDOMAIN = self.generate_index_by(:subdomain)
  BY_HOST = self.generate_index_by_host()
end
