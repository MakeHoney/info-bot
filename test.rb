# module ReusableModule
#     def module_method
#         puts 'Module Method: Hi there!'
#     end
# end

# class ClassThatIncludes
#     # include ReusableModule
# end

# class ClassThatExtends
#     extend ReusableModule
# end

# puts 'include'
# a = ClassThatIncludes.new
# b = ClassThatIncludes.new
# a.extend ReusableModule
# a.module_method
# b.module_method
# puts 'extend'
# ClassThatExtends.module_method

# module DataSet
#     @@
# end