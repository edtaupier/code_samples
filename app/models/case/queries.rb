module Case::Queries

  def self.included(base)
    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
  end

end


module ClassMethods

  def grossed_cases_for_location(location_id, start_date, end_date)
    start_date = DateTime.parse(start_date).query_date_format
    end_date = DateTime.parse(end_date).query_date_format
    sql =  "SELECT #{case_required_select_fields} , "
    sql += "CH.eventTimestamp as grossedOn, CC.firstName as patient_first_name, CC.lastName as patient_last_name, "
    sql += "CHA.eventTimestamp as accessionedOn ,"
    sql += "Status.description as status_description, CT.description as case_type_description, "
    sql += "SUM(S.numberOfBlocks) as numberOfBlocks, "
    sql += "SUM(S.numberOfSlides) as numberOfSlides "
    sql += "FROM Cases "
    sql += "INNER JOIN Specimens S on S.caseID = Cases.caseID "
    sql += "INNER JOIN CaseTypes CT ON CT.caseTypeID = Cases.caseTypeID "
    sql += "INNER JOIN Status ON Status.statusID = Cases.statusID "
    sql += "INNER JOIN PhysiciansLocations PL on PL.physiciansLocationID = Cases.physiciansLocationID "
    sql += "INNER JOIN Locations on Locations.locationID = PL.locationID "
    sql += "INNER JOIN CaseHistories CH on CH.caseID = Cases.caseID "
    sql += "INNER JOIN CaseHistories CHA on CHA.caseID = Cases.caseID "
    sql += "INNER JOIN ClinicalContacts CC on CC.clinicalContactID = Cases.clinicalContactID "
    sql += "WHERE Locations.locationID = '#{location_id}' "
    sql += "AND Cases.statusID != '#{Status::DELETED}' "
    sql += "AND CH.description LIKE 'Case Grossed.' "
    sql += "AND CHA.description LIKE 'Case Accessioned.' "
    sql += "AND CH.eventTimestamp BETWEEN '#{start_date}' AND '#{end_date}' "
    sql += "GROUP BY #{case_required_select_fields},  "
    sql += "CH.eventTimestamp, CC.firstName, CC.lastName, Status.description, CT.description, CHA.eventTimestamp "
    sql += "ORDER BY CH.eventTimestamp"
    find_by_sql(sql)
  end


  private


  def case_required_select_fields()
    list = ["accessionNumber", "hospitalLabId", "caseTypeID", "billingTypeID", "referringPhysicianID", "physiciansLocationID",
     "clinicalContactID", "statusID", "pathologistID", "screenedBy", "reportedBy", "procedureID", "priorityID", "billingStatusID", "createdBy",
     "lastUpdatedBy", "lockedForEditBy", "qaLogTypeId" ,"contactInsuranceProductID", "lockedForBillingEditBy", "preScreenedBy",
      "pcrID", "processedAt", "interpretedAt"].collect{|i| "Cases.#{i}"}
    list.join(",")
  end

end

module InstanceMethods

  def whatever
    puts "whatever"
  end

end