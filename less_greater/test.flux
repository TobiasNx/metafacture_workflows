FLUX_DIR + "test.yaml"
| open-file
| as-records
| decode-yaml
| fix("# greater_than(X,Y) is true when X > Y
if greater_than('year','2018')
	add_field('my.funny.title1','true')
end

	# less_than(X,Y) is true when X < Y
if less_than('year','2018')
 add_field('my.funny.title2','true')
end")
| encode-formeta
| print;