import numpy as np
import matplotlib.pyplot as plt


def linearify(x, y):
    """
    Reshape x and y to create vectors suitable for linear fitting.

    Parameters:
        x (numpy.ndarray): The x values.
        y (numpy.ndarray): The y values.

    Returns:
        numpy.ndarray: Reshaped x values.
        numpy.ndarray: Reshaped y values.
    """
    x = x.flatten()
    y = y.flatten()

    return x, y


def plot_power_law_fit(x, y, y_label, x_label, title, axes=None):
    """
    Plot the data and a power-law fit.

    Parameters:
        x (numpy.ndarray): The x values.
        y (numpy.ndarray): The y values.
        y_label (str): Label for the y axis.
        x_label (str): Label for the x axis.
        title (str): Title for the plot.
        axes (matplotlib.axes.Axes): Axes on which to plot the data.

    Returns:
        float: Slope of the power-law fit.
        float: Intercept (always 0 for a power-law fit).

    Example usage:
        a = 2
        x = np.arange(1, 21) + np.random.rand(20)
        y = x**a + np.random.normal(
            0, 0.1, 20
        )  # Adding some random noise to simulate real-world data
        slope, intercept = plot_power_law_fit(x, y)
        print(f"Slope (power-law exponent): {slope}")
    """
    # Check for NaN values and remove them
    nan_mask = np.isnan(x + y)
    if np.sum(nan_mask) > 0:
        print(f"{np.sum(nan_mask)} NaNs were removed from the data set")
        x = x[~nan_mask]
        y = y[~nan_mask]

    # Prepare data for power-law fitting
    x_lin, y_lin = linearify(x, y)
    x_lin, y_lin = remove_non_positive(x_lin, y_lin)

    # Perform power-law fitting
    slope, intercept = perform_power_law_fit(x_lin, y_lin)

    # Rescale the results for plotting
    ex, yy = rescale_power_law(x_lin, slope, intercept)

    # Plot the data and power-law fit
    plot_data(x, y, ex, yy, y_label, x_label, title, axes)

    return slope, 0  # Intercept is always 0 for a power-law fit


def remove_non_positive(x, y):
    """
    Remove zero or negative values from the data.

    Parameters:
        x (numpy.ndarray): The x values.
        y (numpy.ndarray): The y values.

    Returns:
        numpy.ndarray: x values with non-positive values removed.
        numpy.ndarray: y values with non-positive values removed.
    """
    non_positive_mask = (x > 0) & (y > 0)
    if np.sum(~non_positive_mask) > 0:
        print("Some values were non-positive in your data.")
    return x[non_positive_mask], y[non_positive_mask]


def perform_power_law_fit(x, y):
    """
    Perform power-law fitting on the log-transformed data.

    Parameters:
        x (numpy.ndarray): The x values.
        y (numpy.ndarray): The y values.

    Returns:
        float: Slope of the power-law fit.
    """
    log_x, log_y = np.log10(x), np.log10(y)
    slope, intercept = np.polyfit(log_x, log_y, 1)
    return slope, intercept


def rescale_power_law(x, slope, intercept):
    """
    Rescale the power-law fit results for plotting.

    Parameters:
        x (numpy.ndarray): The x values.
        slope (float): Slope of the power-law fit.
        intercept (float): Intercept of the power-law fit.

    Returns:
        numpy.ndarray: Rescaled x values.
        numpy.ndarray: Rescaled y values.
    """
    ex = np.linspace(np.min(x), np.max(x), 100)
    yy = 10 ** (np.log10(ex) * slope + intercept)
    return ex, yy


def plot_data(x, y, ex, yy, y_label, x_label, title, axes):
    """
    Plot the data and power-law fit.

    Parameters:
        x (numpy.ndarray): The x values.
        y (numpy.ndarray): The y values.
        ex (numpy.ndarray): Rescaled x values for plotting.
        yy (numpy.ndarray): Rescaled y values for plotting.
        y_label (str): Label for the y axis.
        x_label (str): Label for the x axis.
        title (str): Title for the plot.
        axes (matplotlib.axes.Axes): Axes on which to plot the data.
    """
    if axes is None:
        plt.plot(x, y, "bo", markersize=5, label="Data")
        plt.plot(ex, yy, "r--", linewidth=2, label="Power-law Fit")

        plt.title(title)
        plt.xlabel(x_label)
        plt.ylabel(y_label)
        plt.xscale("log")
        plt.yscale("log")

        plt.show()
    else:
        axes.plot(x, y, "bo", markersize=10, label="Data")
        axes.plot(ex, yy, "r--", linewidth=2, label="Power-law Fit")

        axes.set_title(title)
        axes.set_xlabel(x_label)
        axes.set_ylabel(y_label)
        axes.set_xscale("log")
        axes.set_yscale("log")
