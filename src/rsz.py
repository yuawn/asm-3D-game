obj = open("nn_skybox.obj","rb")
res = open("nn_skyboxx500.obj","wb")
    

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
        l2[0] = str( float( l2[0] ) + ( 400. / size ) )
        l2[2] = str( float( l2[2] ) - ( 400. / size ) )
        for i in l2:
            tmp += str( float(i) * size ) + ' '
        res.write( tmp + '\x0a' )
            

resize_v(500);



#print obj.readlines()

obj.close();
res.close();