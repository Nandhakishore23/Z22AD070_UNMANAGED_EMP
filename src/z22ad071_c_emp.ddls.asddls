@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View 22AD071'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z22AD071_C_EMP
 as projection on Z22AD071_I_EMP
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
