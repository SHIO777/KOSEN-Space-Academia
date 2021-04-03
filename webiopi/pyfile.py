import webiopi
import pigpio
import subprocess as proc

"""
WebIOPi
"""

webiopi.setDebug()
pi = pigpio.pi()

# ピン指定
SV_1 = 12       # STEERING
SV_2 = 19       # THROTTLE
SV_3 = 21       # BRAKE


"""サーボ動作"""

# SERVO1
@webiopi.macro
def GET1(val):
    value1 = int(val)
    pi.set_servo_pulsewidth(SV_1, value1)
    webiopi.debug(value1)


# SERVO2
@webiopi.macro
def GET2(val):
    value2 = int(val)
    pi.set_servo_pulsewidth(SV_2, value2)
    webiopi.debug(value2)


@webiopi.macro
def GET3(val):
    value3 = int(val)
    pi.set_servo_pulsewidth(SV_3, value3)
    webiopi.debug(value3)


#********************power.html********************
#シャットダウン実行関数
@webiopi.macro
def ShutCmd():
    proc.call("sudo killall sudo", shell=True)
    proc.call("sudo /sbin/shutdown -h now", shell=True)

#再起動実行関数
@webiopi.macro
def RebootCmd():
    #webiopi.debug("再起動するよ")
    proc.call("sudo killall sudo", shell=True)
    proc.call("sudo /sbin/shutdown -r now", shell=True)
#*****************************************************



