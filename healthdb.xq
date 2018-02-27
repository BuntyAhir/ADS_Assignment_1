(: Ans1: - Display the injury dates for each patient. Sort the result by patient name in ascending order.:)
<Answer1>
{
	for $p in doc("healthdb_WithSchema.xml")//S1_CASES/CASE
	where $p/InjuryDate
	return <result>{$p/InjuryDate , $p/SSN}</result>

}
</Answer1>

(: Ans2: - Print the names of patients who carry a HealthPlan of 'B'. Sort the result based on patient name in ascending order:)
<Answer2>
{
	for $p in doc("healthdb_WithSchema.xml")//S1_PATIENTS/PATIENT
	where $p/HealthPlan = 'B'
	order by $p/PName ascending
	return <result>{$p/HealthPlan , $p/PName}</result>

}
</Answer2>

(: Ans3: - Display the number of patients enrolled for each unique HealthPlan. Sort the result based on the number of patients in descending order.:)
<Answer3>
{
	for $PLAN in distinct-values(doc("healthdb_WithSchema.xml")//HealthPlan)
	let $NUMBER := count(doc("healthdb_WithSchema.xml")//PATIENT[HealthPlan = $PLAN])
	order by $NUMBER descending
	return 
	<PLANCOUNT>
	{$NUMBER} patient enrolled healthplan {$PLAN}
	</PLANCOUNT>

}
</Answer3>

(: Ans4: - Print the names of doctors who treated patients with health plan 'B' and claim type of 'OutPatient':)
<Answer4>
{
	let $h := doc("mailorder-schema.xml")//S3_TRETMENTS
	for $d in $h/S3_TREATMENTS/Dname
	let $h in $h/HealthPan = 'B'
		 return $d/Dname
	return
		<result>
			{$h/Dname}
				<sale>
					{$p}
				</sale>
			</result>

}
</Answer4>

<listings>
	{
		for $c in doc("healthdb_WithSchema.xml")//S3_TRETMENTS
		return
			<return>
			{
				$c/DName
			}
			{
				for $o in doc("healthdb_WithSchema.xml")//PATIENT
				for $p in doc("healthdb_WithSchema.xml")//HealthPlan
				where $o/HealthPlan = $c/SSN and $o//TRETMENT = $p/DName
				return $p/DName
			}
			</return>
	}
</listings>

(: Ans5: - Print the names of patients who have NOT made any claim:)
<Answer5>
{
	for $p in doc("healthdb_WithSchema.xml")//PATIENT
	for $s in doc ("healthdb_WithSchema.xml")//SSN
	let $c := doc("healthdb_WithSchema.xml")//CLAIME[@takenBy = $p]
	return
	if(empty($c))
	then<pname>{$p/PName/text()}</pname>
	else()

}
</Answer5>

(: Abs6: - Print the names of doctors who have treated patients of claim type ‘Emergency:)
<Answer6>
{
	for $TREATMENT in doc("healthdb_WithSchema.xml")//TREATMENT
	for $CLAIM in doc("healthdb_WithSchema.xml")//CLAIM[Type = 'Emergency']
	where $TREATMENT/CaseId = $CLAIM/CaseId
	return <Dname>{$TREATMENT/DName/text()}</Dname>
}

</Answer6>

(: Ans7: - Print the names of patients along with the total amount of claims made by them. Sort the result based on the amount of claims in descending order :)
<Answer7>
{
	let $HEALTHDB := doc("healthdb_WithSchema.xml")//HEALTHDB
	for $PATIENT in $HEALTHDB//PATIENT
	let $TOTALAMOUNT :=sum(
	for $CASE in $HEALTHDB//CASE[SSN = $PATIENT/SSN]
	for $CLAIM in $HEALTHDB//CLAIM[CaseId = $CASE/CaseId]
	return $CLAIM/Amount)
	order by $TOTALAMOUNT descending 
	return
	<COST>
	{string($PATIENT/PName)}
	<TOTALAMOUNT>{$TOTALAMOUNT}</TOTALAMOUNT>
	</COST>

}

</Answer7>
