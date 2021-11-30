project = [
  { name: 'KharkivProject1', description: 'Good' },
  { name: 'KharkivProject2', description: 'Better' },
  { name: 'KharkivProject3', description: 'The Best' },
  { name: 'LvivProject1', description: 'Clever' },
  { name: 'LvivProject2', description: 'Cleverer' },
  { name: 'LvivProject3', description: 'The Cleverest' },
  { name: 'KyivProject1', description: 'Little' },
  { name: 'KyivProject2', description: 'Less' },
  { name: 'KyivProject3', description: 'The least' }

]

project.each do |p|
  Projects.create(p)

end
