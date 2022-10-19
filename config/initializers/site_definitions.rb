class SiteDefinitions
  FACT_CHECK_INSIGHTS = {
    shortname: "fact_check_insights",
    title: "Fact-Check Insights",
    host: Figaro.env.FACT_CHECK_INSIGHTS_HOST,
  }

  MEDIA_VAULT = {
    shortname: "media_vault",
    title: "MediaVault",
    host: Figaro.env.MEDIA_VAULT_HOST,
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

  BY_SHORTNAME = self.generate_index_by(:shortname)
  BY_TITLE = self.generate_index_by(:title)
  BY_HOST = self.generate_index_by(:host)
end
