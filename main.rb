#!/usr/bin/env ruby

require "colorize"

class Cell

	attr_accessor :status

	VERTICAL = "\u007C".encode("utf-8")
	HORIZONTAL = "\u2014".encode("utf-8")
	LEFT_DIAG = "/"
	RIGHT_DIAG = "\\"

	def initialize(status)
		@status = status
	end
end

class MatrixVisualisation

	DEBUG = false
	CLOCKWISE = :clockwise
	ANTICLOCKWISE = :anticlockwise

	def initialize(user_width, user_height)

		@max_width_x = user_width - 1
		@max_height_y = user_height - 1

		create_board()
	end

	# Create the board
	def create_board()

		# Create a board 
		@rows = Array.new(@max_height_y)
		(0..@max_height_y).each do |y|

			@rows[y] = Array.new(@max_width_x)

			(0..@max_width_x).each do |x|

				cells = @rows[y]
				cells[x] = Cell.new(Cell::VERTICAL)
			end
		end
	end

	# Display the board
	def display()

		text = ""
		@rows.each do |y|
			text += "Row: "
			y.each_with_index do |c, i|
				if (i % 2).eql? 0
					text += " #{c.status.colorize(:light_green)} "
				else
					text += " #{c.status.colorize(:light_blue)} "
				end
			end
			text += "\n"
		end
		return "#{text}\n" 
	end

	def modify_status_clockwise(c)

		if c.status.eql? Cell::VERTICAL		
			c.status = Cell::LEFT_DIAG 
		elsif c.status.eql? Cell::LEFT_DIAG
			c.status = Cell::HORIZONTAL
		elsif c.status.eql? Cell::HORIZONTAL
			c.status = Cell::RIGHT_DIAG 
		elsif c.status.eql? Cell::RIGHT_DIAG
			c.status = Cell::VERTICAL 
		end
	end

	def modify_status_anticlockwise(c)

		if c.status.eql? Cell::VERTICAL		
			c.status = Cell::LEFT_DIAG 
		elsif c.status.eql? Cell::LEFT_DIAG
			c.status = Cell::HORIZONTAL
		elsif c.status.eql? Cell::HORIZONTAL
			c.status = Cell::RIGHT_DIAG 
		elsif c.status.eql? Cell::RIGHT_DIAG
			c.status = Cell::VERTICAL 
		end
	end

	# Call the cell selection block to find out which cells to turn
	def turn(direction, cell_selection_block)

		@rows.each do |y|

			y.each_with_index do |c,i|

				if cell_selection_block.call(i)
					# TODO: Push these into a finite state machine
					if direction.eql? CLOCKWISE
						modify_status_clockwise(c)
					elsif direction.eql? ANTICLOCKWISE 
						modify_status_anticlockwise(c)
					end
				end
			end
		end
	end

	def alternate(anim_interval, pattern_interval)

		even = Proc.new { |i| (i % 2).eql? 0 }
		odd = Proc.new { |i| (i % 2) != 0 }

		# Inital state
		system "clear"
		puts display()
		sleep anim_interval

		current_cells = even

		while true

			(1..2).each do
				system "clear"

				if current_cells.eql? even
					turn(MatrixVisualisation::CLOCKWISE, even)
				else 
					turn(MatrixVisualisation::CLOCKWISE, odd)
				end

				puts display()
				sleep anim_interval
			end

			(current_cells.eql? even) ? current_cells = odd : current_cells = even

			sleep pattern_interval
		end
	end
end

visual = MatrixVisualisation.new(20, 20)
visual.alternate(0.2, 0.4)