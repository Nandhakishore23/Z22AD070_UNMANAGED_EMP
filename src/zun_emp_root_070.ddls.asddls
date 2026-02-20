@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zun_emp_root_070 as select from zun_emp_tab_070
{
   key emp_id as EmpId,
   first_name as FirstName,
   last_name as LastName,
   date_of_birth as DateOfBirth,
   email as Email,
   hire_date as HireDate,
   @Semantics.amount.currencyCode: 'curry'
   salary as Salary,
   curry as Curry
}
