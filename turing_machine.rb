class TuringMachine
  ONE = '1'
  EMPTY = '0'#\u2227'.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }      #empty character unicode

  RIGHT = 'right'   #move right
  LEFT = 'left'    #move left
  HALT = 'halt'    #halt (don't move)

  @states = ['q0', 'q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'q7', 'q8', 'q9', 'qF']
  STATES_LENGTH = @states.length - 1


  @tape = String.new

  def initialize
    @multiplicand,
        @multiplier, @product = 0
    @tape = ''
    @rules = Hash.new
  end

  def self.rule(current, new, action, state)
    r = {current: current, new: new, action: action, state: state}
    return r
  end

  @rules = {
      @states[0]=> {ONE => rule(ONE, EMPTY, RIGHT, 1), EMPTY => rule(EMPTY, EMPTY, LEFT, 9)},
      @states[1]=> {ONE => rule(ONE, ONE, RIGHT, 1), EMPTY => rule(EMPTY, EMPTY, RIGHT, 2)},
      @states[2]=> {ONE => rule(ONE, EMPTY, RIGHT, 3), EMPTY => rule(EMPTY, EMPTY, LEFT, 7)},
      @states[3]=> {ONE => rule(ONE, ONE, RIGHT, 3), EMPTY => rule(EMPTY, EMPTY, RIGHT, 4)},
      @states[4]=> {ONE => rule(ONE, ONE, RIGHT, 4), EMPTY => rule(EMPTY, ONE, LEFT, 5)},
      @states[5]=> {ONE => rule(ONE, ONE, LEFT, 5), EMPTY => rule(EMPTY, EMPTY, LEFT, 6)},
      @states[6]=> {ONE => rule(ONE, ONE, LEFT, 6), EMPTY => rule(EMPTY, ONE, RIGHT, 2)},
      @states[7]=> {ONE => rule(ONE, ONE, LEFT, 7), EMPTY => rule(EMPTY, EMPTY, LEFT, 8)},
      @states[8]=> {ONE => rule(ONE, ONE, LEFT, 8), EMPTY => rule(EMPTY, ONE, RIGHT, 0)},
      @states[9]=> {ONE => rule(ONE, ONE, LEFT, 9), EMPTY => rule(EMPTY, EMPTY, RIGHT, 10)},
      @states[10]=> {ONE => rule(ONE, ONE, HALT, 10)#, E => rule(E, E, h, 10)
      }
  }

  def self.ask()
    puts "Please enter your first number (multiplicand)"
    a = gets.chomp();

    puts "Please enter the number you would like to multipy by (multiplier)"
    b = gets.chomp();

    @multiplicand = a.to_i
    @multiplier   = b.to_i
  end

  def self.ones(array, i)
    i.times{array << ONE }
  end

  def self.empties(array, i)
    i.times{array << EMPTY }
  end


  def self.ruleRet(state, value, index)  # for modularity
    return @rules[@states[state]][value][index]
  end

  def self.current(state, value)
     ruleRet(state, value, :current)
  end

  def self.new(state, value)
    ruleRet(state, value, :new)
  end

  def self.action(state, value)
    ruleRet(state, value, :action)
  end

  def self.newState(state, value)
    ruleRet(state, value, :state)
  end

  def self.move(pos, direction)
    case direction
      when  LEFT
        if pos == 0
          return 0
        else
          return pos - 1
        end

      when  RIGHT
        #if pos == STATES_LENGTH
        #  return STATES_LENGTH
        #else
          return pos + 1
        #end

      when HALT
        return pos + 0

    end

  end




  @tape << EMPTY.dup   # create 'empty' tape (ie add initial blank symbol to array)

  #################### INPUT / INITIAL TAPE ###########################################
  ask()           # ask for input
  #  @multiplicand = 2
  #  @multiplier    = 3

  #find product
  @product = (@multiplicand * @multiplier)

  ## append input to tape and print:
    ones(@tape, @multiplicand) #add 1s for input multiplicand
    empties(@tape, 1)          #add seperator
    ones(@tape, @multiplier)   #add 1s for input multiplier
    empties(@tape, @product+2)   #add blank space ready for prospective product output
  print @tape + "\n" #print tape as string

  length = @tape.length    #store tape length

####################################################################
#  empty = 0
#  one = 0
  #@tape.each_with_index do |value, position|
  #  state = :q0
  #
  #  if value == ONE
  #    one += 1
  #  else
  #    empty+= 1
  #  end
  #
  #end
  #
  #puts " ....  1s: #{one}, ^s:' #{empty}"
 ####################################################################

  state = 0       #start in start state (q0)
  pointer = 1       #set pointer to first char

  until state == 10   #Loop until state reaches qF
  current = @tape[pointer]        #store current value

    #store values from rules hash
      newChar = new(state, current)      #store new value
      newState = newState(state, current) #store new state
      direction = action(state, current)  #store direction to move

    #update tape and print
      @tape[pointer] = newChar          #update character
      print  @tape

    #make changes to progress
      state = newState                   #update state
      pointer = move(pointer, direction) #move pointer

    print "[s:#{state}]\t\t\t"
  end

end