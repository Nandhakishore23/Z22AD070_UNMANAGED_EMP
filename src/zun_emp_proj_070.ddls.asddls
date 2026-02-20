@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zun_emp_proj_070 as projection on zun_emp_root_070
{
    key EmpId,
    FirstName,
    LastName,
    DateOfBirth,
    Email,
    HireDate,
    @Semantics.amount.currencyCode: 'Curry'
    Salary,
    Curry
}
