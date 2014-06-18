require 'io/console'
require 'pry'



complex_grid = [
  [2048, 64, 8, 512],
  [512, 8, 4, 128],
  [32, 2, 1024, 8],
  [0, 8, 2, 0]
]

addition_grid = [
  [4, 8, 0, 0],
  [4, 4, 2, 0],
  [4, 4, 0, 0],
  [4, 0, 0, 0],
]

expected = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 8, 2, 0],
]

@grid = addition_grid

def swap(args)
  position = args[:position]
  destination = args[:destination]

  position_value_before       = value_at(position)
  destination_value_before    = value_at(destination)

  set_value_for_cell(position, destination_value_before)
  set_value_for_cell(destination, position_value_before)

end

def set_value_for_cell(cell, value)
  #[2,0]
  row = cell.first
  column = cell.last
  row = @grid[row]
  row[column] = value
end

def move_left

  columns = [0, 1, 2]
  rows = [0, 1, 2, 3]

  # combine down errthing
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |value, column_index|
      cell=[row_index, column_index]
      destination = [row_index, column_index - 1]
      if does_equal(cell, destination)
        set_value_for_cell(cell, 0)
        set_value_for_cell(destination, value * 2 )
      end
    end
  end

  3.times do
    columns.each do |column_number|
      rows.each do |row_number|
        if value_at([row_number, column_number]) == 0
          swap(position: [row_number,column_number + 1], destination: [row_number,column_number])
        end
      end
    end
  end

end

def move_right

  columns = [3, 2, 1]
  rows = [0, 1, 2, 3]

  # combine down errthing
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |value, column_index|
      cell=[row_index, column_index]
      destination = [row_index, column_index + 1]
      if does_equal(cell, destination)
        set_value_for_cell(cell, 0)
        set_value_for_cell(destination, value * 2 )
      end
    end
  end

  3.times do
    columns.each do |column_number|
      rows.each do |row_number|
        if value_at([row_number, column_number]) == 0
          swap(position: [row_number,column_number -1], destination: [row_number,column_number])
        end
      end
    end
  end

end

def move_down

  columns = [0, 1, 2, 3]
  rows = [3, 2, 1]

  # combine down errthing
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |value, column_index|
      cell=[row_index, column_index]
      destination = [row_index + 1, column_index]
      if does_equal(cell, destination)
        set_value_for_cell(cell, 0)
        set_value_for_cell(destination, value * 2 )
      end
    end
  end

  3.times do
    columns.each do |column_number|
      rows.each do |row_number|
        if value_at([row_number, column_number]) == 0
          swap(position: [row_number-1,column_number], destination: [row_number,column_number])
        end
      end
    end
  end

end

def move_up

  columns = [0, 1, 2, 3]
  rows = [0, 1, 2]

  # combine down errthing
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |value, column_index|
      cell=[row_index, column_index]
      destination = [row_index - 1, column_index]
      if does_equal(cell, destination)
        set_value_for_cell(cell, 0)
        set_value_for_cell(destination, value * 2 )
      end
    end
  end

  3.times do
    columns.each do |column_number|
      rows.each do |row_number|
        if value_at([row_number, column_number]) == 0
          swap(position: [row_number + 1,column_number], destination: [row_number,column_number])
        end
      end
    end
  end

end

def matrix_is_full?
  @grid.flatten.all? do |number|
    number > 0
  end
end

def game_is_over?
  full = matrix_is_full?
  pairs = any_adjacent_pairs?
  return full && !pairs
end

def any_adjacent_pairs?
  # for all positions in grid, run any_adjacent?

  found_adjacent = false

  @grid.each_with_index do |row, row_number|

    # 4 columns : 0, 1, 2, 3

    row.each_with_index do |column, index|
      if any_adjacent? row_number, index
        found_adjacent = true
        puts [row_number, index].join(',')
      end
    end

  end
  return found_adjacent

end

def add_random_to_grid
  # forcing 2's to appear more frequently than 4
  # ternary operator
  # if rand() > .6667
  #   2
  # else
  #   4
  # end
  value_to_add = rand() < 0.6667 ? 2 : 4

  chosen_cell = open_cells.sample
  if chosen_cell
    set_value_for_cell(chosen_cell, value_to_add)
  end
end

def open_cells
  cells = []
  @grid.each_with_index do |rows, row_index|
    rows.each_with_index do |columns, column_index|
      if value_at([row_index, column_index]) == 0
        cells << [row_index, column_index]
      end
    end
  end
  cells
end

def any_adjacent?(row, column)
  top = [row-1, column]
  left = [row, column-1]
  down = [row+1, column]
  right = [row, column+1]
  [top, left, down, right].any? do |position|
    does_equal([row, column], position)
  end
end

def does_equal(cell_one, cell_two)

  return false if value_at(cell_one) == 0

  value_at(cell_one) == value_at(cell_two)
end

def value_at(cell)
  x = cell.first
  y = cell.last
  row = @grid[x]
  if valid_index_values?(x, y)
    row[y]
  else
    0
  end
end

def valid_index_values?(x, y)
  [x, y].all? do |value|
    [0, 1, 2, 3].include? value
  end
end


def apply_move_to_grid(move)

  case move.downcase
  when 'w' then move_up
  when 'a' then move_left
  when 'd' then move_right
  when 's' then move_down

  when 'q' then exit
  else
    puts "Sorry, please enter one of w, a, d, s"
  end
end

def run_game


  until game_is_over?
    system "clear" or system "cls"
    print_grid
    move = STDIN.getch
    apply_move_to_grid(move)
    add_random_to_grid

  end
  print_grid

  puts "-----------------------------------"
  puts "[                                 ]"
  puts "[            SO SORRY!!!!!        ]"
  puts "[                                 ]"
  puts "-----------------------------------"



end

def print_grid


  puts "\nEnter Q to quit!\n"
  puts "CONTROLS: w, a, d, s"
  puts "---------------------"
  puts ""
  @grid.each do |row|
    row.each do |i|
      value_to_show = i.to_s
      value_to_show = "" if i == 0
      printf "|%6s|", value_to_show
    end
    print "\n"
  end
end

run_game
