@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'Zemp22ad070_EMP070'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZEMPR_22AD070_EMP070
  as select from Z22AD070_EMP
{
  key emp_id as EmpID,
  emp_name as EmpName,
  department as Department,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  cuky_field as CukyField,
  @Semantics.amount.currencyCode: 'CukyField'
  salary as Salary,
  doj as Doj,
  email as Email,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
