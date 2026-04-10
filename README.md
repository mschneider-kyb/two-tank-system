
# System Dynamics

![system_scheme](data/for_readme/system_schema.svg)


## System specifications

* maximum allowed height of tanks is 30cm
* tank 1 has diameter 5cm
* tank 2 has diameter 4cm
* saturation of allowed volume flow of pump is 2*v_bar. We don't have a real system. In process engineering, actuators (such as pumps) are often designed to operate at their operating point at approximately 50% to 70% of their maximum capacity. Hence, we set the maximum allowed volume flow of the pump to be $2 \cdot v_{\text{bar}}$.
* disturbance: simulates a second pump, pumping constantly water out of the first tank.

# Control Design

## PI Controller

### Learnings

* **Proportional Gain ($K_p$) & Stability**: Increasing $K_p$ improves responsiveness but leads to significant overshoot. Excessive values, especially in combination with integral action, drive the non-linear system into instability or high-frequency oscillations.
* **Integral Action ($K_i$) & Steady-State Error**: An Integral component is mandatory to eliminate steady-state control deviation. Without it, the system exhibits a permanent offset because the open-loop transfer function $G(j\omega)$ converges to a finite value as $\omega \to 0$.
* **System Dynamics & Delay**: Even with optimized controller parameters, the system's response to setpoint changes and disturbances remains slow. This is due to the physical coupling of the tanks: the control input only affects Tank 1 directly, creating a "propagation delay" before influencing the level in Tank 2.
* **Disturbance Rejection**: The PI controller effectively compensates for external disturbances (e.g., constant outflow), but the recovery speed is constrained by the same physical time constants as the setpoint tracking.
* **Linear vs. Non-linear Discrepancy**: While a controller designed for a linearized model can stabilize the non-linear system near the equilibrium point, physical limits (tank height, pump capacity) and non-linear flow characteristics require careful scaling and gain tuning to avoid "Bang-Bang" behavior.

# Project Structure
