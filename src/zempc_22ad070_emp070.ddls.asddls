@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'Zemp22ad070_EMP070'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZEMPC_22AD070_EMP070
  provider contract TRANSACTIONAL_QUERY
  as projection on ZEMPR_22AD070_EMP070
  association [1..1] to ZEMPR_22AD070_EMP070 as _BaseEntity on $projection.EMPID = _BaseEntity.EMPID
{
  key EmpID,
  EmpName,
  Department,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  CukyField,
  @Semantics: {
    Amount.Currencycode: 'CukyField'
  }
  Salary,
  Doj,
  Email,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
