require_relative 'tic_tac_toe'


class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if @board.over?
      return @board.won? && @board.winner != evaluator
    end

    if next_mover_mark == evaluator
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      return @board.won? && @board.winner == evaluator
    end

    if next_mover_mark == evaluator
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end


  # This method generates an array of all moves that can be made after
  # the current move.
  def children

    children_array = []
    @board.rows.each_index do |row_idx|
      @board.rows[row_idx].each_index do |col_idx|
        if @board[[row_idx, col_idx]].nil?
          dup_board = @board.dup
          dup_board[[row_idx, col_idx]] = @next_mover_mark
          next_next_mark = switch_mark
          children_array << TicTacToeNode.new(dup_board, next_next_mark, [row_idx, col_idx])
        end
      end
    end
    children_array
  end

  def switch_mark
    if @next_mover_mark == :x
      :o
    else
      :x
    end
  end

end
