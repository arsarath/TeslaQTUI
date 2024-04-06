#include "hvachandler.h"

HVACHandler::HVACHandler():m_targetTemparature(70)
{}

int HVACHandler::targetTemparature() const
{
    return m_targetTemparature;
}

void HVACHandler::setTargetTemparature(int newTargetTemparature)
{
    if (m_targetTemparature == newTargetTemparature)
        return;
    m_targetTemparature = newTargetTemparature;
    emit targetTemparatureChanged();
}

void HVACHandler::incrementTargetTemparature(const int &val)
{
    int newTargetTemp= m_targetTemparature + val;
    setTargetTemparature(newTargetTemp);
}
