obj = open("lll.obj","rb")
res = open("lllx60.obj","wb")
    

o = ['v']

def resize_v(size):
    ls = obj.readlines()
    for l in ls:
        l2 = l.strip().split(' ')
        if  l2[0] not in o:
            res.write( l )
            continue
        tmp = ''
        tmp += l2[0] + ' '
        l2.remove(l2[0])
        #print l2
        for i in l2:
            print i
            tmp += str( float(i) * size ) + ' '
        res.write( tmp + '\x0a' )
            


resize_v(60);



#print obj.readlines()

obj.close();
res.close();