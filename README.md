# 2-Tank System: Simulation & Control

This project implements a numerical simulation and control design for a non-linear, coupled two-tank system using MATLAB and Simulink. The goal is to regulate the liquid level in the second tank despite external disturbances.

## System Dynamics

![system_scheme](data/for_readme/system_schema.svg)

The system consists of two cylindrical tanks connected in series. Water is pumped from a common reservoir into Tank 1, which then flows into Tank 2.

### Physical Model

The system is described by the following non-linear differential equations based on the principle of mass balance and Torricelli's law:

$$A_1 \dot{h}_1 = v - a_{1} \mu \sqrt{2g h_1} - d$$
$$A_2 \dot{h}_2 = a_{1} \mu \sqrt{2g h_1} - a_{2} \mu \sqrt{2g h_2}$$

Where:

* $h_i$ is the liquid level in tank $i$.
* $A_i$ is the cross-sectional area of tank $i$.
* $v$ is the volumetric inflow from the main pump.
* $d$ is the disturbance flow (simulated as a constant outflow via a second pump).
* $\mu$ is the discharge coefficient.

### Specifications

* **Limits**: Maximum allowed tank height is 30cm to prevent overflow.
* **Actuator Saturation**: To reflect real-world process engineering, the pump is limited to $2 \cdot v_{\text{bar}}$. This assumes the operating point sits at 50% of the maximum capacity.
* **Disturbance**: A secondary pump constanty extracts water from Tank 1, testing the controller's robustness.

## Control Design

### Linearization & Control Strategy

To design the PI controller, the non-linear system is linearized around a steady-state operating point (Equilibrium).

#### Operating Point (Equilibrium)

The equilibrium $(\bar{h}_1, \bar{h}_2)$ is defined by a chosen setpoint $\bar{h}_2$. At this point, the change in levels is zero ($\dot{h}_1 = 0, \dot{h}_2 = 0$):

* $\bar{v} = a_1 \mu \sqrt{2g \bar{h}_1}$
* $a_1 \mu \sqrt{2g \bar{h}_1} = a_2 \mu \sqrt{2g \bar{h}_2} \iff \bar{h}_1 = \frac{a_2^2}{a_1^2}\bar{h}_2$

#### Error Coordinates

For the controller design, we shift the system into error coordinates (deviation variables). This allows the controller to operate on the difference between the current state and the equilibrium:

* $\Delta h_1 = h_1 - \bar{h}_1$
* $\Delta h_2 = h_2 - \bar{h}_2$
* $\Delta v = v - \bar{v}$

The controller's task is to drive the error $\Delta h_2$ to zero.

> **Mathematical Detail**: For the full step-by-step derivation of the linearized state-space representation and the determination of the Jacobi matrices, please refer to the [Detailed Mathematical Derivation](data/for_readme/derivation_of_equations.pdf).

### PI Controller

#### Learnings

* **Proportional Gain ($K_p$) & Stability**: Increasing $K_p$ improves responsiveness but leads to significant overshoot. Excessive values, especially in combination with integral action, drive the non-linear system into instability or high-frequency oscillations.
* **Integral Action ($K_i$) & Steady-State Error**: An Integral component is mandatory to eliminate steady-state control deviation. Without it, the system exhibits a permanent offset because the open-loop transfer function $G(j\omega)$ converges to a finite value as $\omega \to 0$.
* **System Dynamics & Delay**: Even with optimized controller parameters, the system's response to setpoint changes and disturbances remains slow. This is due to the physical coupling of the tanks: the control input only affects Tank 1 directly, creating a "propagation delay" before influencing the level in Tank 2.
* **Disturbance Rejection**: The PI controller effectively compensates for external disturbances (e.g., constant outflow), but the recovery speed is constrained by the same physical time constants as the setpoint tracking.
* **Linear vs. Non-linear Discrepancy**: While a controller designed for a linearized model can stabilize the non-linear system near the equilibrium point, physical limits (tank height, pump capacity) and non-linear flow characteristics require careful scaling and gain tuning to avoid "Bang-Bang" behavior.

## Project Structure
