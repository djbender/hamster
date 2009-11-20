module Hamster

  class Trie

    def initialize(significant_bits = 0, entries = [], children = [])
      @significant_bits = significant_bits
      @entries = entries
      @children = children
    end

    # Returns the number of key-value pairs in the trie.
    def size
      count = 0
      each { count += 1 }
      count
    end

    # Returns <tt>true</tt> if the trie contains no key-value pairs.
    def empty?
      size == 0
    end

    # Returns <tt>true</tt> if the given key is present in the trie.
    def has_key?(key)
      !! get(key)
    end

    # Calls <tt>block</tt> once for each entry in the trie, passing the key-value pair as parameters.
    def each
      @entries.each { |entry| yield entry if entry }
      @children.each do |child|
        child.each { |entry| yield entry } if child
      end
    end

    # Returns a copy of <tt>self</tt> with the given value associated with the key.
    def put(key, value)
      index = index_for(key)
      entry = @entries[index]
      if !entry || entry.key_eql?(key)
        entries = @entries.dup
        entries[index] = Entry.new(key, value)
        self.class.new(@significant_bits, entries, @children)
      else
        children = @children.dup
        child = children[index]
        children[index] = if child
          child.put(key, value)
        else
          self.class.new(@significant_bits + 5).put!(key, value)
        end
        self.class.new(@significant_bits, @entries, children)
      end
    end

    # Retrieves the entry corresponding to the given key. If not found, returns <tt>nil</tt>.
    def get(key)
      index = index_for(key)
      entry = @entries[index]
      if entry && entry.key_eql?(key)
        entry
      else
        child = @children[index]
        if child
          child.get(key)
        end
      end
    end

    # Returns a copy of <tt>self</tt> with the given key (and associated value) removed. If not found, returns <tt>self</tt>.
    def remove(key)
      xxx(key) || Trie.new(@significant_bits)
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      false
    end
    alias :== :eql?

    protected

    # Returns <tt>self</tt> after overwriting the element associated with the specified key.
    def put!(key, value)
      @entries[index_for(key)] = Entry.new(key, value)
      self
    end

    # Returns a replacement instance after removing the specified key.
    # If not found, returns <tt>self</tt>.
    # If empty, returns <tt>nil</tt>.
    def xxx(key)
      index = index_for(key)
      entry = @entries[index]
      if entry && entry.key_eql?(key)
        return remove_at(index)
      else
        child = @children[index]
        if child
          copy = child.xxx(key)
          if !copy.equal?(child)
            children = @children.dup
            children[index] = copy
            return self.class.new(@significant_bits, @entries, children)
          end
        end
      end
      self
    end

    # Returns a replacement instance after removing the specified entry. If empty, returns <tt>nil</tt>
    def remove_at(index = @entries.index { |e| e })
      yield @entries[index] if block_given?
      if size > 1
        entries = @entries.dup
        child = @children[index]
        if child
          children = @children.dup
          children[index] = child.remove_at do |entry|
            entries[index] = entry
          end
        else
          entries[index] = nil
        end
        self.class.new(@significant_bits, entries, children || @children)
      end
    end

    private

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

    class Entry

      attr_reader :key, :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def key_eql?(key)
        @key.eql?(key)
      end

    end

  end

end
