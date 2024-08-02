# Title: CLOVERSPLITTER
# Version: 0.2.2
#
# WARNING: Please be aware that this gem has not undergone any form of security evaluation, and is provided for academic/educational purposes only. This gem is not recommended for usage under mission-critical circumstances and should not be relied upon to protect confidential or secret information, or any information with high availability or integrity requirements. This gem should be treated purely as a proof of concept and/or learning exercise. Users should assume that this gem is insecure and that any data it is used to split into shares may be lost.
#
# Copyright (C) 2020 Peter Bruce Funnell
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require "securerandom"

class CloverSplitter
	def self.eval_at(poly, x, prime)
		# Evaluates polynomial at x (used for share generation).
		accum = 0

		poly.reverse.each do |coeff|
			accum = ((accum*x)+coeff) % prime 
		end

		return accum
	end

	def self.str_to_int(a)
		# Turns an ASCII-8BIT string into an integer.

		# Prepend \x80 to the string to prevent information loss occuring for strings that start with \x00.
		a = "\x80".force_encoding("ASCII-8BIT")+a

		# Decode string into a list of integers (with one integer representing each character).
		b = a.each_byte.to_a

		# Initialise c_b; this will be used to hold bytes (expressed in binary) for each character.
		c_b = String.new()

		# Loop through each value in b, appending the corresponding binary sequence for each character to c_b.
		b.each do |i|
			n = i.to_s(2)
			while n.length < 8 do
				n = "0"+n
			end
			c_b += n
		end

		# Convert c_b into an integer.
		c_b.to_i(2)
	end

	def self.int_to_str(a)
		# Turns an integer into a string.

		# Convert the integer into a string of binary.
		b = a.to_s(2)

		# Add zeroes to the start of the string of binary until the length is a multiple of 8.
		while b.length % 8 != 0 do
			b = "0"+b
		end

		# Convert the string of binary into a list of character values.
		c = []
		c_a = b.chars.each_slice(8).to_a
		c_a.each do |i|
			s = String.new()
			i.each do |j|
				s << j
			end
			c << s.to_i(2)
		end

		# Convert the list of character values back into a string.
		d = String.new()
		c.each do |i|
			d << i.chr
		end

		# Ignore the first byte (which will always be \x80).
		d = d[1, d.length-1]

		return d
	end

	def self.generate_shares(secret, minimum=3, shares=6, prime=((2**3217)-1))
		# This function takes a secret string and spits out a list of shares.
		# Changing the default values for minimum, shares and prime can cause errors or other problems.
		# secret: This argument should be set to the secret string from which the user wishes to generate shares.
		# minimum: The minimum number of shares required to recover the secret. [DEFAULT: 3]
		# shares: The total number of shares to be generated. [DEFAULT: 6]
		# prime: The prime number used for share generation. [DEFAULT: ((2**3217-1)) [NOTE: This is the 18th Mersenne Prime]]

		# Convert the secret into ASCII-8BIT.
		secret = secret.force_encoding("ASCII-8BIT")

		# Convert the secret into an integer.
		secret_int = self.str_to_int(secret)

		# Ensure that the parameters make at least some sense.
		if minimum > shares
			raise("The total number of shares to be generated must equal or exceed the minimum number of shares required for recovery.")
		end

		# Create a list of coefficients for the polynomial, consisting of the secret integer and a series of randomly generated integers.
		# The total length of the list should be the minimum number of shares required for recovery of the secret integer.
		poly = [secret_int]+(Array.new(minimum-1) {(SecureRandom.rand(prime))})

		# Evaluate n points on the polynomial, where n is the total number of shares to be generated.
		points = []
		(1..shares).each do |i|
			points << [i, eval_at(poly, i, prime)]
		end

		# Attempt a test recovery of the secret from the set of all points.
		check = self.recover_secret(points, prime)

		# If the test recovery yielded the original secret, then the shares are valid and should be returned; if not, something went wrong.
		if check == secret
			return points
		else
			raise("Something went wrong during share generation. This could be due to the secret being too long or due to the minimum, shares and/or prime parameters being misconfigured.")
		end
	end

	def self.egcd(a, b)
		# Extended Euclidean algorithm.
		x, y = 0, 1
		last_x, last_y = 1, 0

		while b != 0 do
			quot = a/b
			a, b = b, a % b
			x, last_x = last_x-quot*x, x
			y, last_y = last_y-quot*y, y
		end

		return last_x, last_y
	end

	def self.divmod(num, den, p)
		a, b = egcd(den, p)

		return num*a
	end

	def self.prod(vals)
		# Calculate the product of a list of values.
		accum = 1

		vals.each do |v|
			accum *= v
		end

		return accum
	end

	def self.sum(vals)
		# Calculate the sum of a list of values.
		accum = 0

		vals.each do |v|
			accum += v
		end

		return accum
	end

	def self.lagrange_interpolate(x, x_s, y_s, p)
		k = x_s.length

		if k != x_s.uniq.length
			raise("An error occured during lagrange interpolation.")
		end

		nums = []
		dens = []
		(0..k-1).each do |i|
			others = Array.new(x_s)
			cur = others.delete_at(i)
			nums_a = Array.new()
			dens_a = Array.new()
			others.each do |o|
				nums_a << x-o
				dens_a << cur-o
			end
			nums << prod(nums_a)
			dens << prod(dens_a)
		end

		den = prod(dens)
		num_a = Array.new()
		(0..(k-1)).each do |i|
			num_a << divmod(nums[i]*den*y_s[i] % p, dens[i], p)
		end

		num = sum(num_a)

		return (divmod(num, den, p)+p) % p
	end

	def self.recover_secret(shares, prime=((2**3217)-1))
		# This function takes a list of shares and attempts to recover the secret string from those shares. If the number of shares is below the minimum number of shares required for recovery, the resulting string will be nonsensical and may scramble/gargle the console if printed. On a *nix system, the console can usually be reset with the "reset" command.
		# shares: A list containing two or more shares.
		# prime: The prime number that was used for share generation.

		if shares.length < 2
			raise("At least two shares are required in order to attempt secret recovery.")
		end

		x_s, y_s = shares.transpose

		recovered_data = lagrange_interpolate(0, x_s, y_s, prime)

		return self.int_to_str(recovered_data)
	end
end
