function loadcol(gname::String)
  _e(msg)=error("loadcol: $(msg)")
  !isfile(gname) && e("no such file")
  !endswith(gname,".col") && _e("wrong extension")
  gstring=split(read(gname,String),'\n',keepempty=false)
  E=[]
  nV,nE,tV=-1,-1,-1
  for line in gstring
    startswith(line,'c') && continue
    if startswith(line,'p') # only the last counts
      nV,nE=parse.(Int,split(line)[3:end])
      continue
    end
    if startswith(line,'e') 
      a,b=parse.(Int,split(line)[2:end])
      push!(E,(a,b))
      tV=max(tV,max(a,b))
      continue
    end
  end
  if nV<0 || nE<0 || nV!=tV || length(E)!=nE
    _e("wrong data")
  end
  G=Graph()
  add_vertices!(G,nV)
  for (a,b) in E
    add_edge!(G,a,b)
  end
  G
end
