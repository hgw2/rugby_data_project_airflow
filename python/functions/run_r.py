def run_R(file):
  # COMMAND WITH ARGUMENTS
  cmd = ["Rscript", "myR_script.R", file]

  p = Popen(cmd, cwd="/path/to/folder/of/my_script.R/"      
            stdin=PIPE, stdout=PIPE, stderr=PIPE)     
  output, error = p.communicate()

  # PRINT R CONSOLE OUTPUT (ERROR OR NOT)
  if p.returncode == 0:            
      print('R OUTPUT:\n {0}'.format(output))            
  else:                
      print('R ERROR:\n {0}'.format(error))
