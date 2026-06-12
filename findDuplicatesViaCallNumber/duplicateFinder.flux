infile
| open-file
| as-lines
| decode-json
| fix("if any_equal('type[]','Article')
			reject()
		end

		do list(path:'disambiguatingDescription[]','var':'$i')
			if any_match('$i','(^.*[A-Z1-9]{2} [\\\\-1-9]+).*')
				unless any_match('$i','^.*(UB|FB).*')
					copy_field('$i','callNumber[].$append')
				end
			end
		end
		")
| list-fix-values("callNumber[]", count="false")
| write(FLUX_DIR + "testNeuNoCount.txt")
;