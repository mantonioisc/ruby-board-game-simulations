class Balancer
	def balanced?(parentheses, stack = [])
		parentheses = parentheses.chars.to_a if parentheses.is_a? String

		if parentheses.empty?
			stack.empty?
		else
			tail = parentheses.dup
			head = tail.shift
			if head == "("
				stack.push head
			elsif head == ")"
				peek = stack.pop
				return false unless peek
			else
				#ignore
			end

			balanced?(tail, stack)
		end
	end
end
