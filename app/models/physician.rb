class Physician < ActiveRecord::Base

  set_table_name "Physicians"
  requires_uuids(:physicianID)

  has_many :physician_locations, :foreign_key => "physicianID"
  has_many :suffixes, :through=>:physician_suffixes
  has_many :physician_suffixes, :foreign_key => "physicianID"
  

  def physician_title
    title = firstName
    title += " #{middleName}" if middleName?
    title += " #{lastName}"
    title += ", #{suffix}" if suffix?
    add_suffixes(title)
  end

  private

  def add_suffixes(title)
    physician_suffixes.each_with_index do |ps, i|
      if i == 0
        title += " " + ps.suffix.description
      else
        title += ", " + ps.suffix.description
      end
    end
    title
  end

end