import logging

def setup_logging(log_file='logfile.log', log_level=logging.INFO):
    """
    Set up logging configuration.

    Parameters:
    - log_file: str, the name of the log file (default: 'logfile.log')
    - log_level: int, logging level (default: logging.INFO)

    Returns:
    - logger: logging.Logger, the configured logger
    """
    # Create a logger
    logger = logging.getLogger()
    logger.setLevel(log_level)

    # Create a file handler and set the log level
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(log_level)

    # Create a console handler and set the log level
    console_handler = logging.StreamHandler()
    console_handler.setLevel(log_level)

    # Create a formatter and add it to the handlers
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)

    # Add the handlers to the logger
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger

def simple_logger(message, log_file='logfile.log'):
    """
    Log a message to a file.

    Parameters:
    - message: str, the message to log
    - log_file: str, the name of the log file (default: 'logfile.log')
    """
    
    with open(log_file, 'a') as f:
        f.write(str(message) + '\n')