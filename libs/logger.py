from robot.api.deco import keyword, library
from robot.api import logger
@library
class LogModule():
    def __init__(self):
        pass
    @keyword
    def log_info(self,msg):
        logger.info(msg,also_console=True)   
    @keyword
    def log_debug(self,msg):
        logger.console(msg)
        logger.debug(msg)
    @keyword
    def log_error(self,msg):
        logger.console(msg)
        logger.error(msg)
        

