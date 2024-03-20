class InstallFuzzystrmatchContribPackage < ActiveRecord::Migration[7.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;"
  end

  def down
    execute "DROP EXTENSION IF EXISTS fuzzystrmatch;"
  end
end
