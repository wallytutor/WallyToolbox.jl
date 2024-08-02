classdef BoilerModel
    properties (Constant)
        % Water molecular weight [kg/mol].
        WaterMolecularWeight = 0.018;

        % Water boiling latent heat [J/kg].
        WaterBoilLatentHeat = 2256000;

        % Water heat capacity [J/(kg.K)].
        WaterHeatCapacity = 4200;

        % Water boiling temperature [K].
        WaterBoilingTemp = 373.15;
    end
    
    properties
        % Boiler global heat transfer coefficient [W/K].
        ParamBoilerHtc = 21.0;

        % Boiler water mass [kg].
        ParamBoilerMass = 6.0;

        % Boiler nominal power [W].
        ParamBoilerPower = 6800;

        % Inlet water temperature [K].
        ParamTempRef = 273.15;

        % Environment temperature [K].
        ParamTempEnv = 298.15;

        % Water minumum output [mol/s].
        WaterMinimumOutput = 0.01;

        % Boiler fraction of power to start [-].
        ParamBoilerPowerStart = 1.0;
    end

    methods (Access = private)
        function cv = ConstantCv(self)
            % Constant related to output inertia.
            delta = (self.WaterBoilLatentHeat
                    - self.WaterHeatCapacity * self.ParamTempRef);
            cv = (self.WaterMolecularWeight * delta)^(-1);
        end
        
        function ct = ConstantTheta(self)
            % Constant related to heating inertia.
            ct = (self.ParamBoilerMass * self.WaterHeatCapacity)^(-1);
        end
        
        function cap = BoilerSteamCap(self)
            % Boiler steam generation capacity [mol/s].
            theta  = self.WaterBoilingTemp - self.ParamTempEnv;
            cap = self.ConstantCv() * (self.ParamBoilerPower 
                                       - self.ParamBoilerHtc * theta);
        end
        
        function u = RequestedFlowToPower(self, theta, steamFlow)
            % Convert flow rate to power to feed boiler.
            u = self.ParamBoilerHtc * theta + steamFlow / self.ConstantCv();
        end
        
        function v = BoilerOutputFlow(self, theta, u)
            % Compute output from boiler in [mol/s].
            v = self.ConstantCv() * (u - self.ParamBoilerHtc * theta);
        end
        
        function [u, v] = ComposeCommand(self, theta, steamFlow)
            % Convert flow rate to power and ensure management.
            shouldHeatWater = steamFlow > 0;
            notYetBoiling = theta + self.ParamTempEnv < self.WaterBoilingTemp;

            if (notYetBoiling && shouldHeatWater)
                u = self.ParamBoilerPowerStart * self.ParamBoilerPower;
                v = 0.0;
            else
                u = self.RequestedFlowToPower(theta, steamFlow);
                u = max(0, min(u, self.ParamBoilerPower));
                v = self.BoilerOutputFlow(theta, u);

                if (v <= self.WaterMinimumOutput)
                    u = 0;
                    v = 0;
                end
            end
        end
        
        function [A, B] = ComputeCoefficients(self, u, theta)
            % Compute state space matrices.
            % TODO test if power is supplied too!
            boilerIsOn = u >= self.ParamBoilerHtc * theta;
            boilerBoils = theta + self.ParamTempEnv >= self.WaterBoilingTemp;

            if (boilerIsOn && boilerBoils)
                A = B = 0.0;
            else
                B = self.ConstantTheta();
                A = -B * self.ParamBoilerHtc;
            end
        end
    end
    
    methods
        function sol = SimulateSystem(self, nSteps, timeStep, boilerTemp, steamFlow)
            % Simulate system dynamics with provided actions.
            sol = zeros(nSteps, 5);
            theta = boilerTemp - self.ParamTempEnv;
            cap = self.BoilerSteamCap();

            for t = 1:nSteps
                mv = steamFlow(t) * cap;
                [u, v] = self.ComposeCommand(theta, mv);
                sol(t, 1:end) = [(t - 1) * timeStep theta u mv v];

                [A, B] = self.ComputeCoefficients(u, theta);
                theta = theta + timeStep * (A * theta + B * u);
            end
        end
        
        function PlotResponse(self, sol)
            % PLOT RESPONSE
            %   Display integrated solution in time.
            t = sol(:, 1);
            T = sol(:, 2) + self.ParamTempEnv;
            P = sol(:, 3) * 100 / self.ParamBoilerPower;
            U = sol(:, 4) * self.WaterMolecularWeight * 3600;
            V = sol(:, 5) * self.WaterMolecularWeight * 3600;

            figure;

            subplot(3, 1, 1);
            plot(t, T, 'k', 'linewidth', 4); hold on;
            grid on; set(gca, 'GridLineStyle', ':');
            xlabel('Time [s]'); ylabel('Temperature [K]');

            subplot(3, 1, 2);
            plot(t, U, 'g', 'linewidth', 4); hold on;
            plot(t, V, 'r', 'linewidth', 4); hold on;
            grid on; set(gca, 'GridLineStyle', ':');
            xlabel('Time [s]'); ylabel('Flow rate [kg/h]');
            h = legend({'SP ', 'PV '});  
            set(h, "fontsize", 6);

            subplot(3, 1, 3);
            plot(t, P, 'r', 'linewidth', 4); hold on;
            grid on; set(gca, 'GridLineStyle', ':');
            xlabel('Time [s]'); ylabel('Relative power [%]');
        end
    end
end