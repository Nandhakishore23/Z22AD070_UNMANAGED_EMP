@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view 22AD071'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z22AD071_I_EMP
 as select from z22ad071_emp
{
 key emp_id as EmpId,
 first_name as FirstName,
 last_name as LastName,
 date_of_birth as DateOfBirth,
 email as Email,
 hire_date as HireDate,
 @Semantics.amount.currencyCode: 'Curry'
 salary as Salary,
 curry as Curry
}
