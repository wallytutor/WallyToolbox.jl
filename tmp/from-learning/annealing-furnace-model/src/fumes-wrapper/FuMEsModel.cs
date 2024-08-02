using System;
using System.Runtime.InteropServices;

namespace FuMEsWrapper
{
    public class FuMEsModel
    {
        private const string libraryName = "fumes-core.dll";
        private const CallingConvention convention = CallingConvention.Cdecl;

        public FuMEsOutputs Outputs { get; private set; }

        public FuMEsModel(FuMEsInputs inputs)
        {
            FuMEsRunExplicit(ref inputs, out int len, out IntPtr tk,
                out IntPtr x0, out IntPtr x1, out IntPtr x2, out IntPtr uk,
                out IntPtr vk, out IntPtr rk, out IntPtr qk);

            Outputs = new FuMEsOutputs
            {
                tk = GetArrayFromIntPtr(len, tk),
                x0 = GetArrayFromIntPtr(len, x0),
                x1 = GetArrayFromIntPtr(len, x1),
                x2 = GetArrayFromIntPtr(len, x2),
                uk = GetArrayFromIntPtr(len, uk),
                vk = GetArrayFromIntPtr(len, vk),
                rk = GetArrayFromIntPtr(len, rk),
                qk = GetArrayFromIntPtr(len, qk)
            };
        }

        private double[] GetArrayFromIntPtr(int len, IntPtr arrPtr)
        {
            // https://stackoverflow.com/questions/36224120
            double[] arr = new double[len];
            Marshal.Copy(arrPtr, arr, 0, len);
            Marshal.FreeCoTaskMem(arrPtr);
            return arr;
        }

        [DllImport(libraryName, CallingConvention = convention)]
        private static extern void FuMEsRunExplicit(ref FuMEsInputs inputs, out int len,
            out IntPtr tk, out IntPtr x0, out IntPtr x1, out IntPtr x2, out IntPtr uk,
            out IntPtr vk, out IntPtr rk, out IntPtr qk);
    }
}
