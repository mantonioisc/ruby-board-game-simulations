class PascalTriangle
	def pascal c,r
		return 1 if c == 0 || c == r
		pascal(c-1,r-1) + pascal(c, r-1)
	end
end
